from pathlib import Path
from markupsafe import Markup

from .generator import Generator


def typst_escape(s):
    """Escape common problematic characters in Typst code like #, $."""
    if isinstance(s, Markup):
        return s
    if not isinstance(s, str):
        return s

    typst_replacements = {
        '\\': r'\\',
        '#': r'\#',
        '$': r'\$',
        '*': r'\*',
        '_': r'\_',
        '`': r'\`',
        '<': r'\<',
        '>': r'\>',
        '@': r'\@',
    }
    s = s.translate(str.maketrans(typst_replacements))
    return Markup(s)


def make_typstdoc(game, out_dir: Path) -> None:
    """Generate the Typst documentation of a game"""

    gen = Generator(
        'typstdoc',
        game=game,
        out_dir=out_dir,

        block_start_string='<%',
        block_end_string='%>',
        variable_start_string='<<',
        variable_end_string='>>',
        comment_start_string='<#',
        comment_end_string='#>',
        finalize=typst_escape,

        autoescape=True,
    )

    for tpl in ["apidoc.typ", "useapi.typ"]:
        gen.template(tpl)
