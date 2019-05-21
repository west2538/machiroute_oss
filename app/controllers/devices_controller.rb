class DevicesController < ApplicationController

    before_action :current_user

    def create
        device = @current_user.devices.find_or_initialize_by endpoint: params[:subscription][:endpoint]
        device.endpoint = params[:subscription][:endpoint]
        device.p256dh = params[:subscription][:keys][:p256dh]
        device.auth = params[:subscription][:keys][:auth]
        # device.attributes = device_params
        device.save! if device.changed?
        head :ok
    end

    # private

    # def device_params
    #     # params.require(:subscription).permit(%i(endpoint p256dh auth))
    #     params.require(:subscription).permit(:endpoint, keys: [:p256dh, :auth])
    # end
end