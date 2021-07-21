import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  connect() {
    Rails.ajax({
      type: "get",
      url: "https://umlsait.atlassian.net/s/d41d8cd98f00b204e9800998ecf8427e-T/r5gghz/b/3/e73395c53c3b10fde2303f4bf74ffbf6/_/download/batch/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs.js?locale=en-US&collectorId=51ecac03",
      cache: true,
      dataType: "script"
    })

  }

  report(e) {
    e.preventDefault();
    window.ATL_JQ_PAGE_PROPS =  {
    "triggerFunction": function(showCollectorDialog) {
      showCollectorDialog();
    }};
  }
}
