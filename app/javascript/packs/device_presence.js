$(document).ready(function () {
    $('#form').submit(function () {
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
            console.log("All fields are required");
            return false;
        }
    });
});

