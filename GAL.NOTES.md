Notes:

* Assuming we don't want blue "success messages" displaying "0 items clearanced in batch 8", and that was just an after thought. Modified it so that if there are 0 items there is no blue success message.
* Changed to not use Flash[] to render the success and error messages because there is a limit in the size that can be passed in using flash.
* I included include ActionView::Helpers::NumberHelper in the model even though its an MVC violation, I decided its worth the trade off

* Still TODO if this was a real project:

- test performance of really large batches and optimize / make it useable
- upgrade from sqlite, most likely
- I used the old hash format   (:value => 'key') because I like that better. I didn't go back and change all the old code to that format but that should happen in a real project if you switch conventions. (Also generally you stick to whatever are the team conventions, I assumed this is an imaginary new team for which I can set the conventions!)
- I don't validate the values that come in through the barcode scanner / item ID data entry. It assumes everything is just perfect.
- Right now the clearancing service can accept a file or a string of ID's. That may no belong there, it maybe the controller job's, or some helper. (The clearancing service would be purer if it just received a collection of hashes without knowing where they came from)
- The clearancing controller was cleaned up a lot but I think it could still use more work - its still doing too much / a little bit too much code to look at. Perhaps I would extract antoher service class out of it or helper.
- handle clicking on "upload" without selecting a file
