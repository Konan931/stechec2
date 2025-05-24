from pathlib import Path

from .generator import Generator


def make_markdowndoc(game, out_dir: Path) -> None:
    """Generate the Sphinx documentation of a game"""

    gen = Generator('markdowndoc', game=game, out_dir=out_dir)

    for tpl in ["api.md", "userapi.md"]:
        gen.template(tpl)
