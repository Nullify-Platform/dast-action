#!/bin/bash
setup_nullify_auth() {
  local config_file="${1:-~/.nullify/auth_config.json}"
  mkdir -p $(dirname "$config_file")
  
  if [ ! -z "$INPUT_USER_1_ROLE" ]; then
    echo "Using individual user parameters for authorization model"
    cat > "$config_file" << EOJSON
{
  "authorizationModel": true,
  "users": [
EOJSON
    local first_user=true
    for i in {1..4}; do
      role_var="INPUT_USER_${i}_ROLE"
      user_description_var="INPUT_USER_${i}_DESCRIPTION"
      if [ -z "${!role_var}" ]; then
        continue
      fi      
      if [ "$first_user" = true ]; then
        first_user=false
      else
        echo "    ," >> "$config_file"
      fi
      cat >> "$config_file" << EOJSON
    {
      "roleName": "${!role_var}",
      "roleDescription": "User with ${!role_var} permissions",
      "userDescription": "${!user_description_var}",
      "authConfig": {
EOJSON
      username_var="INPUT_USER_${i}_USERNAME"
      password_var="INPUT_USER_${i}_PASSWORD"
      token_var="INPUT_USER_${i}_TOKEN"
      client_id_var="INPUT_USER_${i}_CLIENT_ID"
      client_secret_var="INPUT_USER_${i}_CLIENT_SECRET"
      token_url_var="INPUT_USER_${i}_TOKEN_URL"
      scope_var="INPUT_USER_${i}_SCOPE"
      login_url_var="INPUT_USER_${i}_LOGIN_URL"
      login_body_var="INPUT_USER_${i}_LOGIN_BODY"
      login_selector_var="INPUT_USER_${i}_LOGIN_SELECTOR"
      custom_headers_var="INPUT_USER_${i}_CUSTOM_HEADERS"
      custom_params_var="INPUT_USER_${i}_CUSTOM_PARAMS"
      auth_method_var="INPUT_USER_${i}_AUTH_METHOD"
      if [ ! -z "${!username_var}" ]; then
        echo "\"method\": \"basic\", \"username\": \"${!username_var}\", \"password\": \"${!password_var}\"" >> "$config_file"
      elif [ ! -z "${!token_var}" ]; then
        echo "\"method\": \"bearer\", \"token\": \"${!token_var}\"" >> "$config_file"
      elif [ ! -z "${!client_id_var}" ]; then
        echo "\"method\": \"oauth2\", \"clientId\": \"${!client_id_var}\", \"clientSecret\": \"${!client_secret_var}\", \"tokenUrl\": \"${!token_url_var}\", \"scope\": \"${!scope_var}\"" >> "$config_file"
      elif [ ! -z "${!login_url_var}" ]; then
        echo "\"method\": \"session\", \"loginUrl\": \"${!login_url_var}\", \"loginBody\": ${!login_body_var}, \"loginSelector\": \"${!login_selector_var}\"" >> "$config_file"
      elif [ ! -z "${!custom_headers_var}" ]; then
        echo "\"method\": \"custom\", \"customHeaders\": ${!custom_headers_var}, \"customParams\": ${!custom_params_var}" >> "$config_file"
      else
        echo "\"method\": \"none\"" >> "$config_file"
      fi
      echo "      }" >> "$config_file"
      echo "    }" >> "$config_file"
    done
    
    echo "  ]" >> "$config_file"
    echo "}" >> "$config_file"
    
  else
    # Single user mode (standard authentication)
    echo "Using standard single-user authentication"
    
    # If INPUT_AUTH_USERNAME is provided, use basic auth
    if [ ! -z "$INPUT_AUTH_USERNAME" ]; then
      echo "Auth username detected, using basic authentication"
      cat > "$config_file" << EOJSON
{
  "method": "basic",
  "username": "$INPUT_AUTH_USERNAME",
  "password": "$INPUT_AUTH_PASSWORD"
}
EOJSON
    elif [ ! -z "$INPUT_AUTH_TOKEN" ]; then
      echo "Auth token detected, using bearer authentication"
      cat > "$config_file" << EOJSON
{
  "method": "bearer",
  "token": "$INPUT_AUTH_TOKEN"
}
EOJSON
    else
      # Use the specified auth method
      echo "Using specified auth method: $INPUT_AUTH_METHOD"
      cat > "$config_file" << EOJSON
{
  "method": "$INPUT_AUTH_METHOD",
  "userDescription": "$INPUT_AUTH_USER_DESCRIPTION"
EOJSON
      
      case "$INPUT_AUTH_METHOD" in
        basic)
          echo ', "username": "'"$INPUT_AUTH_USERNAME"'", "password": "'"$INPUT_AUTH_PASSWORD"'"' >> "$config_file"
          ;;
        bearer|jwt)
          echo ', "token": "'"$INPUT_AUTH_TOKEN"'"' >> "$config_file"
          ;;
        oauth2)
          echo ', "clientId": "'"$INPUT_AUTH_CLIENT_ID"'", "clientSecret": "'"$INPUT_AUTH_CLIENT_SECRET"'", "tokenUrl": "'"$INPUT_AUTH_TOKEN_URL"'", "scope": "'"$INPUT_AUTH_SCOPE"'"' >> "$config_file"
          ;;
        session)
          echo ', "loginUrl": "'"$INPUT_AUTH_LOGIN_URL"'", "loginBody": '"$INPUT_AUTH_LOGIN_BODY"', "loginSelector": "'"$INPUT_AUTH_LOGIN_SELECTOR"'"' >> "$config_file"
          ;;
        custom)
          echo ', "customHeaders": '"$INPUT_AUTH_CUSTOM_HEADERS"', "customParams": '"$INPUT_AUTH_CUSTOM_PARAMS"'' >> "$config_file"
          ;;
      esac
      
      echo '}' >> "$config_file"
    fi
  fi
  
  if [ ! -z "$INPUT_AUTH_HEADER" ]; then
    echo "Header specified, will use that instead of auth config"
  fi
  echo "Created authentication configuration in $config_file:"  
  return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  config_file="${1:-~/.nullify/auth_config.json}"
  setup_nullify_auth "$config_file"
fi