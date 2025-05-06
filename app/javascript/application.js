import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";
import "controllers";

// import "jquery";
// import "select2"; 
// import "script";

const application = Application.start();
const context = require.context("controllers", true, /\.js$/);
application.load(definitionsFromContext(context));
