import subprocess
import re
import webbrowser
import sublime
import sublime_plugin


class OpenOnGithubCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        file_path = self.view.file_name()
        if not file_path:
            sublime.status_message("No file to open on GitHub")
            return

        try:
            repo_root = subprocess.check_output(
                ["git", "rev-parse", "--show-toplevel"],
                cwd=file_path.rsplit("/", 1)[0],
                text=True,
            ).strip()

            remote_url = subprocess.check_output(
                ["git", "remote", "get-url", "origin"],
                cwd=repo_root,
                text=True,
            ).strip()

            branch = subprocess.check_output(
                ["git", "rev-parse", "--abbrev-ref", "HEAD"],
                cwd=repo_root,
                text=True,
            ).strip()
        except subprocess.CalledProcessError:
            sublime.status_message("Not a git repository")
            return

        # Convert remote URL to HTTPS base
        if remote_url.startswith("git@"):
            remote_url = re.sub(r"^git@(.+?):", r"https://\1/", remote_url)
        if remote_url.endswith(".git"):
            remote_url = remote_url[:-4]

        rel_path = file_path[len(repo_root) + 1:]

        # Get line number(s)
        sel = self.view.sel()[0]
        start_line = self.view.rowcol(sel.begin())[0] + 1
        end_line = self.view.rowcol(sel.end())[0] + 1

        line_fragment = f"L{start_line}"
        if end_line != start_line:
            line_fragment += f"-L{end_line}"

        url = f"{remote_url}/blob/{branch}/{rel_path}#{line_fragment}"
        webbrowser.open(url)
        sublime.status_message(f"Opened on GitHub: {rel_path}#{line_fragment}")

    def is_enabled(self):
        return self.view.file_name() is not None
