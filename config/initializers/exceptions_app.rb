Rails.application.configure do
    config.exceptions_app = self.routes
end