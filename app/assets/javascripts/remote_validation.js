( function( $ ) {
    var RemoteValidation = {
      defaults: {
        messageContainer : '#error_messages',
        messageHtml : "<div id='error_explanation'>{{ERRORS}}</div>",
        noErrorClass: 'field',
        errorClass : 'field_with_errors'
      },
      resetErrors: function(form, settings) {
         $(settings.messageContainer).empty();
         $("."+settings.errorClass, form).children().unwrap();
      },
      showErrors: function(form, settings, errors) {
        var errorList ="";
        var formFor = $(form).attr('id').replace(/new_|edit_/,"").replace(/_[0-9]+$/,"");
        var numErrors = 0;
        for (var col in errors) {
          for (var i in errors[col]) {
            errorList += "<li> "+errors[col][i]+"</li>";
            $("*[name='"+formFor+"["+col+"]']", form).wrap($("<div/>").addClass(settings.errorClass));
            $("label[for='"+formFor+"_"+col+"']", form).wrap($("<div/>").addClass(settings.errorClass));
            numErrors++;
          }
        }
        var errorHtml = settings.messageHtml.replace("{{NUM_ERRORS}}", numErrors);
        errorHtml = errorHtml.replace("{{ERRORS}}","<ul>"+errorList+"</ul>");
        $(settings.messageContainer).append(errorHtml);
      }
    };

    $.fn.serializeFiles = function() {
      var form = $(this),
          formData = new FormData(),
          formParams = form.serializeArray();
  
      $.each(form.find('input[type="file"]'), function(i, tag) {
        $.each($(tag)[0].files, function(i, file) {
          formData.append(tag.name, file);
        });
      });
  
      $.each(formParams, function(i, val) {
        formData.append(val.name, val.value);
      });
  
      return formData;
    };


    $.fn.remoteValidation = function(options) {
      var settings = $.extend({}, RemoteValidation.defaults, options );
      return this.each( function() {
        var $this = this; //$(this), may change inside function, so assign it to $this.
        $(this).submit(function() {

          $.ajax({
            url: $(this).attr('action'),
            type: $(this).attr('method') || 'GET', 
            data: $(this).serializeFiles(),
            dataType: $(this).data('type') || 'json',
            crossDomain: null, 
            processData: false,
            contentType: false,
            beforeSend: function(xhr) {
              RemoteValidation.resetErrors($this, settings);
              if (typeof settings.beforeSend == 'function') {
                settings.beforeSend.apply($this, [xhr]);
              }
            },
            success: function(data, status, xhr) {
              if (data.errors) { // 200 response, but errors are specified
                RemoteValidation.showErrors($this, settings, data.errors);
              } else if (data.location) {  // 200 response, but redirect required
                window.location.href = data.location;
              }
              if (typeof settings.success == 'function') {
                settings.success.apply($this, [data, status, xhr]);
              }
            },
            error: function(xhr, status, error) {
              var data = JSON.parse(xhr.responseText);
              RemoteValidation.showErrors($this, settings, data);
              if (typeof settings.error == 'function') {
                settings.error.apply($this, [xhr, status, error]);
              }
            },
            complete: function(xhr, status) {
              if (typeof settings.complete == 'function') {
                settings.complete.apply($this, [xhr, status]);
              }
            }
          });
          return false;
        }); // $(this).submit
      }) // return this.each
    } // $.fn.remoteValidation
  })(jQuery);