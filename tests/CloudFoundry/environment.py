import os
import datetime
import yaml

import config

from cloudfoundry import Client


def before_feature(context, feature):
    """ Creates a work space before Access Control feature is tested """
    admin_client = Client(
        api_url=config.API_URL,
        username=config.MASTER_USERNAME,
        password=config.MASTER_PASSWORD,
        verify_ssl=False
    )
    # Create and org
    org = admin_client.create_org(config.TEST_ORG)
    # Create a space
    space = org.create_space(config.TEST_SPACE)
    if 'Cloud Controller' in feature.name:
        # Create accounts that will be used and set permissions
        admin = admin_client.get_user(config.MASTER_USERNAME)
        org.set_user_role('user', admin.guid)
        org.set_user_role('manager', admin.guid)
        space.set_user_role('user', admin.guid)
        space.set_user_role('manager', admin.guid)

        org_manager = admin_client.create_user(
            config.ORG_MANAGER,
            config.ORG_MANAGER_PASSWORD,
        )
        org.set_user_role('user', org_manager.guid)
        org.set_user_role('manager', org_manager.guid)

        org_auditor = admin_client.create_user(
            config.ORG_AUDITOR,
            config.ORG_AUDITOR_PASSWORD,
        )
        org.set_user_role('user', org_auditor.guid)
        org.set_user_role('auditor', org_auditor.guid)

        space_manager = admin_client.create_user(
            config.SPACE_MANAGER,
            config.SPACE_MANAGER_PASSWORD,
        )
        org.set_user_role('user', space_manager.guid)
        space.set_user_role('user', space_manager.guid)
        space.set_user_role('manager', space_manager.guid)

        space_developer = admin_client.create_user(
            config.SPACE_DEVELOPER,
            config.SPACE_DEVELOPER_PASSWORD,
        )
        org.set_user_role('user', space_developer.guid)
        space.set_user_role('user', space_developer.guid)
        space.set_user_role('developer', space_developer.guid)

        space_auditor = admin_client.create_user(
            config.SPACE_AUDITOR,
            config.SPACE_AUDITOR_PASSWORD,
        )
        org.set_user_role('user', space_auditor.guid)
        space.set_user_role('auditor', space_auditor.guid)

    if 'Application Security Groups' in feature.name:
        admin_client.create_security_group(
            name=config.CLOSED_SECURITY_GROUP,
            rules=[{
              "protocol": "udp",
              "destination": "1.1.1.1",
              "ports": "1"
            }]
        )
        admin_client.create_security_group(
            name=config.OPEN_SECURITY_GROUP,
            rules=[{
              "protocol": "all",
              "destination": "0.0.0.0-255.255.255.255",
            }]
        )


# Afters
def after_feature(context, feature):
    """ Destroys a work space after Access Control feature is tested """
    admin_client = Client(
        api_url=config.API_URL,
        username=config.MASTER_USERNAME,
        password=config.MASTER_PASSWORD,
        verify_ssl=False
    )

    if 'Cloud Controller' in feature.name:
        # Delete users
        admin_client.get_user(config.ORG_MANAGER).delete()
        admin_client.get_user(config.ORG_AUDITOR).delete()
        admin_client.get_user(config.SPACE_MANAGER).delete()
        admin_client.get_user(config.SPACE_DEVELOPER).delete()
        admin_client.get_user(config.SPACE_AUDITOR).delete()

    if 'Application Security Groups' in feature.name:
        admin_client.get_security_group(
            name=config.OPEN_SECURITY_GROUP).delete()
        admin_client.get_security_group(
            name=config.CLOSED_SECURITY_GROUP).delete()

    # Delete org and space
    org = admin_client.get_org(config.TEST_ORG)
    space = org.get_space(config.TEST_SPACE)
    space.delete()
    org.delete()


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
        data['description'] = context.scenario.name
        data['filename'] = context.scenario.filename
        data['steps'] = get_steps(context.scenario)
    else:
        # This is a feature
        data['name'] = context.feature.name
        data['filename'] = context.feature.filename
        data['steps'] = get_scenarios(context.feature)    
    return data


def after_tag(context, tag):
    if 'Component' in tag:
        _, name, system, component = tag.split('-')
        component_file = os.path.join(
            '..', '..', 'data', 'components', system,
            component, 'component.yaml'
        )
        test_data = extract_data(context)
        test_data['name'] = name
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
