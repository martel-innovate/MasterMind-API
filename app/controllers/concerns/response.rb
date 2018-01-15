module Response
  # Render response into JSON
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
