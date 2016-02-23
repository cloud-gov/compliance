import sys
sys.path.append('../')
from tagger import tag_component


def after_tag(context, tag):
    tag_component(context, tag)
