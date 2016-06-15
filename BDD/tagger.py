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
        data['path'] = os.path.join('BDD', context.scenario.filename)
        data['description'] = get_steps(context.scenario)
    else:
        # This is a feature
        data['name'] = context.feature.name
        data['path'] = os.path.join('BDD', context.feature.filename)
        data['description'] = get_scenarios(context.feature)
    return data


def tag_component(context, tag):
    if 'Verify' in tag:
        _, key, component = tag.split('-')
        component_file = os.path.join('..', component, 'component.yaml')
        test_data = extract_data(context)
        test_data['key'] = key

        with open(component_file, 'r') as yaml_file:
            # Get Component Data
            data = yaml.load(yaml_file)
            if 'verifications' not in data:
                data['verifications'] = []
            # Delete Old Data
            for idx, verification in enumerate(data['verifications']):
                if verification.get('key') == key:
                    del data['verifications'][idx]
            # Add New Data
            data['verifications'].append(test_data)
        with open(component_file, 'w') as yaml_file:
            yaml_file.write(
                yaml.safe_dump(data, default_flow_style=False, indent=2)
            )
