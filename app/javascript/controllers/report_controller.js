import { Controller } from "stimulus"

export default class ReportController extends Controller {
  static targets = ["form", "data_type", "classification_level"]

  changeClassification() {
    console.log("hell")
    var id = this.classification_levelTarget.value
    console.log(id)
    if (id) {
      fetch(`/data_classification_levels/get_data_types/${id}`)
        .then((response) => response.json())
        .then((data) => this.update_data_type(data)
        );
    }

  }

  update_data_type(data) {
    console.log(data)
    let dropdown = this.data_typeTarget;
    dropdown.length = 0;

    let defaultOption = document.createElement('option');
    defaultOption.text = 'Select data type...';

    dropdown.add(defaultOption);
    dropdown.selectedIndex = 0;

    let option;
    for (let i = 0; i < data.length; i++) {
      option = document.createElement('option');
      option.value = data[i].id;
      option.text = data[i].name;
      dropdown.add(option);
    }
  }

  submitForm(event) {
    console.log("submit")

  }

  // submitForm(event) {
  //     var serial = this.serialTarget.value
  //     var hostname = this.hostnameTarget.value
  //     if (serial == "" && hostname == "") {
  //         this.serial_errorTarget.classList.add("device-error--display")
  //         this.serial_errorTarget.classList.remove("device-error--hide")
  //         this.hostname_errorTarget.classList.add("device-error--display")
  //         this.hostname_errorTarget.classList.remove("device-error--hide")
  //         event.preventDefault()
  //     }
  //     else {
  //         this.serial_errorTarget.classList.add("device-error--hide")
  //         this.serial_errorTarget.classList.remove("device-error--display")
  //         this.hostname_errorTarget.classList.add("device-error--hide")
  //         this.hostname_errorTarget.classList.remove("device-error--display")
  //     }
  // }

}