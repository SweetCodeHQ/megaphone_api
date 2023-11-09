class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    # Also need to check for non-admin actions that the signed in user can only query its own data
    authorization_key = request.env['HTTP_AUTHORIZATION']
    query_type = query&.split(" ").first
    check_api_key(authorization_key, query_type)
    puts [authorization_key, query_type]
    result = MegaphoneApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def check_api_key(key, query_type)
    check_format(key)
    if request.env['HTTP_AUTHORIZATION'] == ENV['EAGLE_KEY']
       nil
    elsif query_type == "mutation"
      key == ENV['MUTATION_KEY'] ? nil : (raise ActionController::BadRequest.new('Entry Denied'))
    elsif query_type == "query"
      key == ENV['QUERY_KEY'] ? nil : (raise ActionController::BadRequest.new('Entry Denied'))
    else
      raise ActionController::BadRequest.new('Entry Denied')
    end
  end

  def check_format(key)
    key ? key_array = key.split("_") : (raise ActionController::BadRequest.new('Entry Denied'))
    if key_array.first == ENV['API_PREFIX'] && key_array.last == ENV['API_SUFFIX']
      return
    else
      raise ActionController::BadRequest.new('Entry Denied')
    end
  end

  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
