import json

import sublime
import sublime_plugin

_decoder = json.JSONDecoder()


class JsonFoldStatusListener(sublime_plugin.ViewEventListener):
    """Shows item/key counts in the status bar for JSON arrays and objects."""

    STATUS_KEY = "json_fold_info"

    @classmethod
    def is_applicable(cls, settings):
        syntax = settings.get("syntax", "")
        return "JSON" in syntax

    def on_selection_modified_async(self):
        sel = self.view.sel()
        if not sel:
            return

        cursor_line = self.view.line(sel[0].begin())

        # Check folded regions first
        for region in self.view.folded_regions():
            if self.view.line(region.begin()).intersects(cursor_line):
                info = self._describe_fold(region)
                if info:
                    self.view.set_status(self.STATUS_KEY, info)
                    return

        # Check for [ or { on current line
        info = self._describe_container_at(cursor_line)
        if info:
            self.view.set_status(self.STATUS_KEY, info)
            return

        self.view.erase_status(self.STATUS_KEY)

    def _describe_container_at(self, line_region):
        """Parse the last [ or { on the line and count its contents."""
        line_text = self.view.substr(line_region)

        # Find last [ or { on the line (handles "key": [ pattern)
        pos = None
        for i in range(len(line_text) - 1, -1, -1):
            if line_text[i] in "[{":
                pos = i
                break

        if pos is None:
            return None

        start = line_region.begin() + pos
        size = min(1_000_000, self.view.size() - start)
        text = self.view.substr(sublime.Region(start, start + size))

        try:
            parsed, _ = _decoder.raw_decode(text)
        except (json.JSONDecodeError, ValueError):
            return None

        if isinstance(parsed, list):
            return "[ %d items ]" % len(parsed)
        if isinstance(parsed, dict):
            return "{ %d keys }" % len(parsed)
        return None

    def _describe_fold(self, region):
        if region.size() > 1_000_000:
            return None

        parsed = self._parse_fold(region)
        if parsed is None:
            return None

        if isinstance(parsed, list):
            return "[ %d items ]" % len(parsed)
        if isinstance(parsed, dict):
            return "{ %d keys }" % len(parsed)
        return None

    def _parse_fold(self, region):
        content = self.view.substr(region)

        # Try parsing as-is (fold includes brackets)
        stripped = content.strip()
        if stripped:
            try:
                parsed = json.loads(stripped)
                if isinstance(parsed, (list, dict)):
                    return parsed
            except (json.JSONDecodeError, ValueError):
                pass

        # Fold excludes brackets — check surrounding characters
        begin = region.begin()
        end = region.end()
        opener = self.view.substr(begin - 1) if begin > 0 else ""
        closer = self.view.substr(end) if end < self.view.size() else ""

        wrap = None
        if opener == "[" and closer == "]":
            wrap = ("[", "]")
        elif opener == "{" and closer == "}":
            wrap = ("{", "}")

        if wrap:
            try:
                return json.loads(wrap[0] + content + wrap[1])
            except (json.JSONDecodeError, ValueError):
                pass

        return None
