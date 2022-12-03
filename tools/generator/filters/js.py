from typing import List

from . import register_filter
from .common import (generic_comment, is_array, is_returning, camel_case,
                     get_array_inner, is_tuple)


@register_filter
def ts_type(ty: str) -> str:
    base_types = {
        'void': 'void',
        'bool': 'boolean',
        'int': 'number',
        'double': 'number',
        'string': 'string',
    }
    if is_array(ty):
        return '{}[]'.format(ts_type(get_array_inner(ty)))
    elif ty in base_types:
        return base_types[ty]
    else:
        return camel_case(ty)


@register_filter
def ts_tuple_type(tup) -> str:
    assert is_tuple(tup), "{} is not a tuple struct".format(tup)
    return '[{}]'.format(
        ', '.join(ts_type(field) for _, field, _ in tup['str_field']))


@register_filter
def ts_func_signature(func) -> str:
    func_args = ', '.join(
        '{}: {}'.format(name, ts_type(ty)) for name, ty, _ in func['fct_arg'])
    return '{}({}): {}'.format(
        camel_case(func['fct_name'], upper=False),
        func_args,
        ts_type(func['fct_ret_type']))


def js_doc_comment_inner(vals: List[str], indent: int = 0) -> str:
    comment = ('\n' + ' ' * indent).join(
        generic_comment(val, ' * ', indent) for val in vals)
    return '/**\n{indent}{}\n{indent} */'.format(comment, indent=' ' * indent)


@register_filter
def js_doc_comment(val: str, indent: int = 0) -> str:
    return js_doc_comment_inner([val], indent)


@register_filter
def js_doc_tuple(tup) -> str:
    fields = ['- {}'.format(field) for _, _, field in tup['str_field']]
    return js_doc_comment_inner([tup['str_summary'], '', 'Fields :'] + fields)


@register_filter
def js_doc_function(func, types: bool = False) -> str:
    annotations = [
        '@param {}{} - {}'.format(
            '{{{}}} '.format(arg_ty) if types else '', arg_name, arg_comment)
        for arg_name, arg_ty, arg_comment in func['fct_arg']]
    if types and is_returning(func):
        annotations.append(
            '@returns {{{}}}'.format(ts_type(func['fct_ret_type'])))
    return js_doc_comment_inner([func['fct_summary']] + annotations)


@register_filter
def js_func_definition(func) -> str:
    args = ', '.join(
        camel_case(arg, upper=False) for arg, _, _ in func['fct_arg'])
    return '{}({})'.format(camel_case(func['fct_name'], upper=False), args)


@register_filter
def cxx_to_js(value: str) -> str:
    if is_array(value):
        return 'cxx_to_js_array'
    else:
        return 'cxx_to_js'


@register_filter
def js_to_cxx(value: str) -> str:
    if is_array(value):
        return 'js_to_cxx_array'
    else:
        return 'js_to_cxx'
