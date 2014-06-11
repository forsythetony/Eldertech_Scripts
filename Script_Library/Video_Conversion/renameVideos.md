### Purpose

To rename videos within a folder, specifically changing the date in the name of the video, so that videos of in a certain range will be moved to a different date range. Also, the first few folders will be copied to create and their dates changed to the beginning of the new date range, effectively 'adding' videos to the beginning of the new date range.

### How to Use

1. Before starting the script modify the following in the getRanges function:
   * For switch option 1:
      * The $fromStartDateString and $fromEndDateString should be changed to the old start and end of the first date range respectively.
      * The $toStartDateString and $toEndDateString should be changed to the new start and end of the first date range respectively.
   * For switch option 2:
      * Same as for switch option 1 except for the second date range.
  * For switch option 3:
      * The $fromStartDateString should be changed to the $toStartDateString value of switch 1 and $fromEndDateString should be changed to 3 days after switch 3's $fromStartDateString value.
      * The $toStartDateString and $toEndDateString should be changed to the new start and end values of the third date range respectively. This range will start 4 day's before switch 3's $toStartDateString and end 1 day before that value.

### Disclaimer

I really don't think anyone else is going to use this script but if they do I apologize for making it so confusing. I'd rewrite it but why bother?
