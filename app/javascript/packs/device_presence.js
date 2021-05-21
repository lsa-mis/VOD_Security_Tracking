$(document).ready(function () {
    $('input[type="submit"]').on('click', function () {
        serial = $("input[id$=serial").val();
        hostname = $("input[id$=hostname").val();

        if ((serial == "" && hostname != "") || (serial != "" && hostname == "")) {
            var errors = 0;
        }
        else {
            var errors = 1
        }
        if (errors > 0) {
            $('#device_input').append("<p>Add serial number or hostname</p>");
            document.getElementById(id = "legacy_os_record_device_attributes_serial").focus();
            console.log("All fields are required");
            return false;
        }
    });
});