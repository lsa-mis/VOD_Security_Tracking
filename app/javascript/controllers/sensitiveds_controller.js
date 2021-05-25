import { Controller } from "stimulus"

export default class SensitivedsController extends Controller {
  static targets = ["sensitive_data_system_type", "system_device", "form", "serial", "hostname"]

  connect() {
    console.log("hello from StimulusJS - hell!!!!!")
    this.display_device()
  }

  display_device() {
    console.log("display device")
    var type = this.sensitive_data_system_typeTarget.value
    console.log("type: ")
    console.log(type)
    if (type == 1) {
      this.system_deviceTarget.classList.add("device--display")
      this.system_deviceTarget.classList.remove("device--hide")
    }
    else {
      this.system_deviceTarget.classList.add("device--hide")
      this.system_deviceTarget.classList.remove("device--display")
    }
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
    var system_type = this.sensitive_data_system_typeTarget.value
    // var system_type = $("#sensitive_data_system_sensitive_data_system_type_id").val()
    console.log("system_type: ")
    console.log(system_type)
    console.log("system_deviceTarget")
    console.log(this.system_deviceTarget)
    // var serial = $("input[id$=serial").val();
    var serial = this.serialTarget.value
    console.log("serial: ")

    console.log(serial)
    // var hostname = $("input[id$=hostname").val();
    var hostname = this.hostnameTarget.value
    console.log("hostname: ")

    console.log(hostname)



    if (system_type == 1) {
      if ((serial == "" && hostname != "") || (serial != "" && hostname == "")) {
        isValid = true;
      }
      else {
        isValid = false;
      }

      return isValid;
    }
  }
}