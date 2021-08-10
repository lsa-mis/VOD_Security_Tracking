import { Controller } from "stimulus"

export default class ReportController extends Controller {
  static targets = ["form", "data_type", "classification_level", "review_month", "message", "table", "end_date", "review_month_div"]

  checkReviewMonth() {
    var table = this.tableTarget.value
    if (table == "isi") {
      this.review_month_divTarget.classList.remove("device--display")
      this.review_month_divTarget.classList.add("device--hide")
    }
    else {
      this.review_month_divTarget.classList.add("device--display")
      this.review_month_divTarget.classList.remove("device--hide")
    }
  }

  changeClassification() {
    var id = this.classification_levelTarget.value
    if (id) {
      fetch(`/data_classification_levels/get_data_types/${id}`)
        .then((response) => response.json())
        .then((data) => this.update_data_type(data)
        );
    }
    else {
      id = 0
      fetch(`/data_classification_levels/get_data_types/${id}`)
        .then((response) => response.json())
        .then((data) => this.update_data_type(data)
        );
    }

  }

  update_data_type(data) {
    let dropdown = this.data_typeTarget;
    dropdown.length = 0;

    let defaultOption = document.createElement('option');
    defaultOption.value = '';
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
    var review_month = this.review_monthTarget.value
    var classification_level = this.classification_levelTarget.value
    var data_type = this.data_typeTarget.value
    if (review_month == "" && classification_level == "" && data_type == "") {
      this.messageTarget.classList.add("device-error--display")
      this.messageTarget.classList.remove("device-error--hide")
      this.messageTarget.innerText = "Select a review month or data classification level or data type";
      event.preventDefault()
    }
    else {
      console.log(this.messageTarget.classList)
      this.messageTarget.classList.add("device-error--hide")
      this.messageTarget.classList.remove("device-error--display")
      this.messageTarget.innerText = ""
    }

  }

  clearFilters() {
    this.element.reset()
  }

}