Functionality changes notes:

* Assuming we don't want blue "success messages" displaying "0 items clearanced in batch 8", and that was just an after thought. Modified it so that if there are 0 items there is no blue success message.
* Changed to not use Flash[] to render the success and error messages because there is a limit in the size that can be passed in using flash.


* I included include ActionView::Helpers::NumberHelper in the model even though its an MVC violation, I decided its worth the trade off
