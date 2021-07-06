import { Controller } from "stimulus"

export default class LegacyosController extends Controller {
    static targets = ["form", "system_device", "serial", "hostname", "serial_error", "hostname_error"]

    submitForm(event) {
        var serial = this.serialTarget.value
        var hostname = this.hostnameTarget.value
        if (serial == "" && hostname == "") {
            this.serial_errorTarget.classList.add("device-error--display")
            this.serial_errorTarget.classList.remove("device-error--hide")
            this.hostname_errorTarget.classList.add("device-error--display")
            this.hostname_errorTarget.classList.remove("device-error--hide")
            event.preventDefault()
        }
        else {
            this.serial_errorTarget.classList.add("device-error--hide")
            this.serial_errorTarget.classList.remove("device-error--display")
            this.hostname_errorTarget.classList.add("device-error--hide")
            this.hostname_errorTarget.classList.remove("device-error--display")
        }
    }

}