<script>
    $(document).ready(function() {
        $('#booking_patron_id').on('select2:select', function(e) {

            // Grab data from the event
            var data = e.params.data;

            // Grab the flatPickr instance
            var periodPicker = $("#period").get(0)._flatpickr;

            // Grab patron delivery group
            let patron_id = data.id;
            if (patron_id) {
                let query = JSON.stringify({
                    "group_patrons.patron_id": patron_id
                });
                var groups = $.ajax({
                    url: '/api/v1/contrib/logistics/groups?q=' + query,
                    headers: {
                        'x-koha-embed': 'group_patrons',
                    },
                    dataType: 'json',
                    type: 'GET'
                });

                $.when(groups).then(
                    function(groups) {
                        // Highlight logistics days in the periodPicker
                        // FIXME: We cannot disable other days as disabling would prevent ranges being
                        // selected that span the disabled days.
                        for (group of groups) {
                            console.log(group);
                            periodPicker.config.onDayCreate.unshift(function(dObj, dStr, fp, dayElem) {
                                console.log(dayElem);
                                if (dayElem.dateObj.getDay() == group.active) {
                                    // Highlight our delivery day
                                    dayElem.classList.add("logistic");
                                }
                            });
                        }
                        // redraw the periodPicker taking logistics days into account
                        periodPicker.redraw();
                    }
                );
            }
        });
    });
</script>
