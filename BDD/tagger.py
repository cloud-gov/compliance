import datetime
import os
import yaml


def get_steps(scenario):
    text = ''
    for step in scenario.steps:
        text += step.step_type.upper() + ' ' + step.name + ' '
    return text


def get_scenarios(feature):
    text = ''
    for scenario in feature.scenarios:
        text += get_steps(scenario)
        text += '\n'
    return text


def extract_data(context):
    data = {
        'type': 'TEST',
        'test_passed': not context.failed,
        'last_run': datetime.datetime.now()
    }
    if hasattr(context, 'scenario'):
        # This is a scenario
        data['name'] = context.scenario.name
        data['filename'] = context.scenario.filename
        data['steps'] = get_steps(context.scenario)
    else:
        # This is a feature
        data['name'] = context.feature.name
        data['filename'] = context.feature.filename
        data['steps'] = get_scenarios(context.feature)
    return data


def tag_component(context, tag):
    if 'Component' in tag:
        _, name, system, component = tag.split('-')
        component_file = os.path.join(
            '..', '..', 'data', 'components', system,
            component, 'component.yaml'
        )
        test_data = extract_data(context)
        test_data['name'] = name
        test_data['key'] = name
        with open(component_file, 'r') as yaml_file:
            # Get Component Data
            data = yaml.load(yaml_file)
            if 'verifications' not in data:
                data['verifications'] = []
            # Delete Old Data
            for idx, verification in enumerate(data['verifications']):
                if verification.get('name') == name:
                    del data['verifications'][idx]
            # Add New Data
            data['verifications'].append(test_data)
        with open(component_file, 'w') as yaml_file:
            yaml_file.write(
                yaml.dump(data, default_flow_style=False, indent=2)
            )
