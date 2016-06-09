# singularity_executor [![Build Status](https://travis-ci.org/evertrue/singularity_executor-cookbook.svg)](https://travis-ci.org/evertrue/singularity_executor-cookbook)

Installs the (fairly poorly documented) HubSpot Singularity custom executor.

# Recipes

## default

The only one you need. Installs the executor

# Usage

Include this recipe in a wrapper cookbook:

```
depends 'singularity_executor', '~> 1.0'
```

```
include_recipe 'singularity_executor::default'
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests with `kitchen test`, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Author:: Evertrue, Inc (devops@evertrue.com)
