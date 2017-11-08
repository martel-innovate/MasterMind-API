Swagger::Docs::Config.base_api_controller = ActionController::API

class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    # Make a distinction between the APIs and API documentation paths.
    "apidocs/#{path}"
  end
end

Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the output location where your .json files are written to
    :api_file_path => "public/apidocs/",
    # the URL base path to your API
    :base_path => "http://localhost:3000",
    # if you want to delete all .json files at each generation
    :clean_directory => false,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        "title" => "MasterMind API",
        "description" => "The MasterMind API component",
        "contact" => "gabriele.cerfoglio@martel-innovate.com",
        "license" => "Apache 2.0",
        "licenseUrl" => "http://www.apache.org/licenses/LICENSE-2.0.html"
      }
    }
  }
})
