import { Controller } from "stimulus"
import Rails from "@rails/ujs"
export default class ReportController extends Controller {
  static targets = ["form", "data_type", "classification_level", "review_month", "message",
    "table", "end_date", "start_date", "end_date"]

  checkReviewMonth() {
    var table = this.tableTarget.value
    var review_month = this.review_monthTarget.value
    console.log("review_month")
    console.log(review_month)

    // failed attrempt to dissable revew_month dropdown list
    // var review_month = this.review_monthTarget
    // console.log("review_month.attributes")
    // console.log(review_month.attributes)
    // review_month.attributes.add('disabled')
    // console.log(review_month.attributes[3])
    // console.log(review_month.attributes[3].value)
    // console.log(review_month.attributes['disabled'])

    if (table != "isi" && review_month != "") {
      console.log("here")
      this.messageTarget.classList.add("device-error--hide")
      this.messageTarget.classList.remove("device-error--display")
      this.messageTarget.innerText = ""
    }
    if (table == "isi" && review_month != "") {
      this.messageTarget.classList.add("device-error--display")
      this.messageTarget.classList.remove("device-error--hide")
      this.messageTarget.innerText = "IT security table is not included into the Review month - select a different table or All";
    }
  }

  checkTable() {
    var table = this.tableTarget.value
    var review_month = this.review_monthTarget.value
    if (table == "isi" && review_month != "") {
      this.messageTarget.classList.add("device-error--display")
      this.messageTarget.classList.remove("device-error--hide")
      this.messageTarget.innerText = "IT security table is not included into the Review month - select a different table or All";
    }
    else {
      this.messageTarget.classList.add("device-error--hide")
      this.messageTarget.classList.remove("device-error--display")
      this.messageTarget.innerText = ""
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
    console.log("submt")

    console.log(this.messageTarget.innerText)
    // if (this.messageTarget.innerText == " ") {
    //   console.log("here")
    //   event.preventDefault()
    // }
    // else {

    var review_month = this.review_monthTarget.value
    var classification_level = this.classification_levelTarget.value
    var data_type = this.data_typeTarget.value
    let start = this.start_dateTarget.value;
    let end = this.end_dateTarget.value;
    var d_start = Date.parse(start)
    var d_end = Date.parse(end)
    if (review_month == "" && classification_level == "" && data_type == "" && start == "" && end == "") {
      this.messageTarget.classList.add("device-error--display")
      this.messageTarget.classList.remove("device-error--hide")
      this.messageTarget.innerText = "Select a review month or data classification level or data type or date range";
      event.preventDefault()
      return
    }
    else if (d_end < d_start) {
      this.messageTarget.classList.add("device-error--display")
      this.messageTarget.classList.remove("device-error--hide")
      this.messageTarget.innerText = "[From] date should occur before [To] date";
      event.preventDefault()
    }
    else {
      console.log(this.messageTarget.classList)
      this.messageTarget.classList.add("device-error--hide")
      this.messageTarget.classList.remove("device-error--display")
      this.messageTarget.innerText = " "
    }
    // }
    // let start = this.start_dateTarget.value;
    // let end = this.end_dateTarget.value;
    // console.log(start)
    // var d_start = Date.parse(start)
    // console.log(d_start)
    // var d_end = Date.parse(end)
    // console.log(d_end)
    // if (d_end < d_start) {
    //   this.messageTarget.classList.add("device-error--display")
    //   this.messageTarget.classList.remove("device-error--hide")
    //   this.messageTarget.innerText = "[From] date should occur before [To] date";
    //   event.preventDefault()
    // }
    // else {
    //   console.log(this.messageTarget.classList)
    //   this.messageTarget.classList.add("device-error--hide")
    //   this.messageTarget.classList.remove("device-error--display")
    //   this.messageTarget.innerText = ""
    // }

  }

  clearFilters() {
    this.element.reset()
    this.changeClassification()

    console.log(this.messageTarget.classList)
    this.messageTarget.classList.add("device-error--hide")
    this.messageTarget.classList.remove("device-error--display")
    this.messageTarget.innerText = " "
    console.log("in clearFilters")
    // this.clearReport()
  }

  clearReport() {
    console.log("hell")
    // var data = new FormData();
    fetch(`/run_report?table=all&review_month=current&data_classification_level_id=&data_type_id=&report_data%5Bstart_date%5D=&report_data%5Bend_date%5D=&format=html&commit=Clear`)

    // Rails.ajax({
    //   url: '/run_report',
    //   type: 'GET',
    //   data: { commit: 'Clear' }
    // })

  }

  // get reportController() {
  //   console.log("hell")
  //   console.log(this.application.getControllerForElementAndIdentifier(element, "run_report"))
  //   return this.application.getControllerForElementAndIdentifier(element, "run_report")
  // }

}