class WellknownController < ApplicationController

    def assetlinks
        render file: '.well-known/assetlinks.json', layout: false, content_type: 'text/json'        
    end

end