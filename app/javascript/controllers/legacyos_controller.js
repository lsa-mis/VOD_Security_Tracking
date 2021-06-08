import { Controller } from "stimulus"

export default class LegacyosController extends Controller {
    static targets = ["form", "system_device", "serial", "hostname"]

    submitForm(event) {
        let isValid = this.validateForm(this.formTarget);
        if (!isValid) {
            this.system_deviceTarget.append("Add serial number or hostname");
            event.preventDefault();
        }
    }

    validateForm() {
        let isValid = true;
        var serial = this.serialTarget.value
        var hostname = this.hostnameTarget.value
        if ((serial == "" && hostname != "") || (serial != "" && hostname == "")) {
            isValid = true;
        }
        else {
            isValid = false;
        }
        return isValid;
    }
}