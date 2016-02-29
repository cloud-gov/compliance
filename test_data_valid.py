from glob import iglob
from pykwalify.core import Core

import yaml


def get_schema():
    return yaml.load(open('schemas/opencontrol-component-kwalify-schema.yaml'))


def test_component_data_valid():
    """ Check that the content of data fits with masonry schema v2 """
    validator = Core(source_data={}, schema_data=get_schema())
    for component_file in iglob('CloudGov/*/*/component.yaml'):
        source_data = yaml.load(open(component_file))
        validator.source = source_data
        try:
            validator.validate(raise_exception=True)
        except:
            assert False, "Error found in: {0}".format(component_file)
