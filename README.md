# env_parameters_handler

manipulations with env files parameters 

Usage: ./env_parameter.sh COMMAND PARAMETER_NAME (VALUE) (FILE_MASK ...)

COMMAND: add / remove / update

EXAMPLES:

./env_parameter.sh  add MY_PARAMETER  my_value   .env*

./env_parameter.sh  update MY_PARAMETER  new_value .env*

./env_parameter.sh  remove MY_PARAMETER .env*

