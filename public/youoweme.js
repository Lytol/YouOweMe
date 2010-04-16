$(document).ready(function() {
    $("input:text, textarea").focus(function() {
        if ($(this).val() == $(this).attr("title")) {
            $(this).removeClass("default-text");
            $(this).val("");
        }
    });
    
    $("input:text, textarea").blur(function() {
        if ($(this).val() == "") {
            $(this).addClass("default-text");
            $(this).val($(this).attr("title"));
        }
    });
    
    $("input:image, input:button, input:submit").click(function() {
        $(':input', this.form).each(function() {
            if($(this).attr("type") == "text" || $(this).tagName == "textarea") {
                if($(this).val() == $(this).attr("title") && $(this).val() != "") {
                    $(this).val("");
                }
            }
        });
        return true;
    });
    
    $("input:text, textarea").blur();
});