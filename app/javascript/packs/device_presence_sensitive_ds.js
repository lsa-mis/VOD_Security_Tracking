$(document).ready(function () {
    $('input[type="submit"]').on('click', function () {

        var system_type = $("#sensitive_data_system_sensitive_data_system_type_id").val()
        var serial = $("input[id$=serial").val();
        console.log(serial)
        var hostname = $("input[id$=hostname").val();

        if (system_type == 1) {
            if ((serial == "" && hostname != "") || (serial != "" && hostname == "")) {
                var errors = 0;
            }
            else {
                var errors = 1
            }
            if (errors > 0) {
                $('#device_input').append("<p>Add serial number or hostname</p>");
                document.getElementById(id = "sensitive_data_system_device_attributes_serial").focus();
                return false;
            }
        }
    });
});