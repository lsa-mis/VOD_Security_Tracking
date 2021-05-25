import { Controller } from "stimulus"

export default class LegacyosController extends Controller {
    static targets = ["form", "system_device", "serial", "hostname"]


    connect() {
        console.log("hello from StimulusJS - hell!!!!!")
    }

    submitForm(event) {
        console.log('form submitted');
        let isValid = this.validateForm(this.formTarget);

        // If our form is invalid, prevent default on the event
        // so that the form is not submitted
        if (!isValid) {
            this.system_deviceTarget.append("Add serial number or hostname");
            event.preventDefault();
        }
    }

    validateForm() {
        let isValid = true;
        console.log('call validateForm');

        // Tell the browser to find any required fields
        // let requiredFieldSelectors = 'textarea:required, input:required';
        // let requiredFields = this.formTarget.querySelectorAll(requiredFieldSelectors);

        // requiredFields.forEach((field) => {
        //   // For each required field, check to see if the value is empty
        //   // if so, we focus the field and set our value to false
        //   if (!field.disabled && !field.value.trim()) {
        //     field.focus();

        //     isValid = false;
        //   }
        // });

        var serial = this.serialTarget.value
        console.log("serial: ")

        console.log(serial)
        // var hostname = $("input[id$=hostname").val();
        var hostname = this.hostnameTarget.value
        console.log("hostname: ")

        console.log(hostname)



        if ((serial == "" && hostname != "") || (serial != "" && hostname == "")) {
            isValid = true;
        }
        else {
            isValid = false;
        }

        return isValid;

    }
}