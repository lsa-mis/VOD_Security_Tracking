$(document).ready(function () {
    $('#form').submit(function () {
        serial = $('#legacy_os_record_device_attributes_serial').val();
        hostname = $('#legacy_os_record_device_attributes_hostname').val()
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

