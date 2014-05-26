S3BucketBrowser
===============

Just experimenting with Amazon's AWS API for S3

as of 2014-05-14:
   * can authenticate with amazon given an auth key, secret, and bucket name (provided the credentials are correctly configured on amazon's side to access the given bucket)
   * after authentication, lists the filenames contained in the bucket and stores list in Core Data
   * tapping a given filename shows the attributes of that file, provided by s3
   * tapping a given file attribute displays that attribute full-screen (so longer attribute values can be examined in detail)
   * file attributes screen includes a "show file" entry, which will attempt do display the file in question.  currently works with any iOS-supported image file formats, html formats, and text files.
   * bucket file list can be sorted by key (i.e. filename), file size, or last modified date.  ascending or descending.
