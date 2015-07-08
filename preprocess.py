import argparse
import jinja2
import os
import yaml


def process_entity(processed_inputs_struct, entity, entity_structs):
    """Expand entity config by flattening structs into key-value pairs.

    Args:
      processed_inputs_struct: {dict<str key, str value>} resulting dictionary.
      entity: {str} name of the entity.
      entity_structs: {list<dict>} structs to be flattened.
    """
    for i, entity_struct in enumerate(entity_structs):
        for key, value in entity_struct.items():
            key_i = '{0}_{1}_{2}'.format(entity, i+1, key)
            processed_inputs_struct[key_i] = value


def preprocess(blueprint_template, inputs):
    """Preprocess the given Jinja blueprint template and complex input.

    Args:
      blueprint_template: {jinja2.Template}.
      inputs: {str}.

    Returns:
      {tuple<str rendered_blueprint, str processed_inputs_yaml>}.
    """
    raw_inputs_struct = yaml.load(inputs)
    processed_inputs_struct = {}
    for key, value in raw_inputs_struct.items():
        if isinstance(value, basestring):
            processed_inputs_struct[key] = value
        elif isinstance(value, list):
            # convert to singular
            entity = key.rstrip('s')
            process_entity(processed_inputs_struct, entity, value)
    processed_inputs_yaml = yaml.dump(processed_inputs_struct,
                                      default_flow_style=False)
    rendered_blueprint = blueprint_template.render(**raw_inputs_struct)
    return rendered_blueprint, processed_inputs_yaml


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Preprocess blueprint using inputs file.')
    parser.add_argument('-p', dest='blueprint', help='Blueprint file')
    parser.add_argument('-i', dest='inputs', help='Inputs file')
    args = parser.parse_args()
    template_dir = os.path.dirname(os.path.abspath(args.blueprint))
    blueprint_basename = os.path.basename(os.path.abspath(args.blueprint))
    template_loader = jinja2.FileSystemLoader(searchpath=template_dir)
    template_env = jinja2.Environment(loader=template_loader)
    blueprint_template = template_env.get_template(blueprint_basename)
    # TODO UTF-8?
    rendered_blueprint, processed_inputs_yaml = preprocess(
        blueprint_template, open(args.inputs).read())
    with open(args.blueprint.replace('.yaml', '_processed.yaml'),
              'w') as output_file:
        output_file.write(rendered_blueprint)
    with open(args.inputs.replace('.yaml', '_processed.yaml'),
              'w') as output_file:
        output_file.write(processed_inputs_yaml)
