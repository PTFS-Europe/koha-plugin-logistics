<script>
    $(document).ready(function() {
        $('#addPatronToGroupModal').on('show.bs.modal', function(e) {
            var button = $(e.relatedTarget);
            var group_id = button.data('group_id');
            $('#add_patron_to_group_group_id').val(group_id);

            // Patron select2
            $("#add_patron_to_group_patron_id").kohaSelect({
                dropdownParent: $(".modal-content", "#addPatronToGroupModal"),
                width: '30%',
                dropdownAutoWidth: true,
                allowClear: true,
                minimumInputLength: 3,
                ajax: {
                    url: '/api/v1/patrons',
                    delay: 250,
                    dataType: 'json',
                    data: function(params) {
                        var search_term = (params.term === undefined) ? '' : params.term;
                        var query = {
                            'q': JSON.stringify({
                                "-or": [{
                                        "firstname": {
                                            "-like": search_term + '%'
                                        }
                                    },
                                    {
                                        "surname": {
                                            "-like": search_term + '%'
                                        }
                                    },
                                    {
                                        "cardnumber": {
                                            "-like": search_term + '%'
                                        }
                                    }
                                ]
                            }),
                            '_order_by': 'firstname',
                            '_page': params.page,
                        };
                        return query;
                    },
                    processResults: function(data, params) {
                        var results = [];
                        data.results.forEach(function(patron) {
                            results.push({
                                "id": patron.patron_id,
                                "text": escape_str(patron.firstname) + " " + escape_str(patron.surname) + " (" + escape_str(patron.cardnumber) + ")"
                            });
                        });
                        return {
                            "results": results,
                            "pagination": {
                                "more": data.pagination.more
                            }
                        };
                    },
                },
                placeholder: "Search for a patron"
            });

            // Position select2
            $("#add_patron_to_group_position_id").select2({
                dropdownParent: $(".modal-content", "#addPatronToGroupModal"),
                width: '30%',
                dropdownAutoWidth: true,
                minimumResultsForSearch: 20,
                placeholder: "Select position"
            });

            // Fetch list of attached patrons
            var patrons = $.ajax({
                url: '/api/v1/contrib/logistics/groups/' + group_id + '/patrons?_per_page=-1',
                dataType: 'json',
                type: 'GET'
            });

            // Update position select2
            $.when(patrons).then(
                function(patrons) {
                    for (patron of patrons) {
                        if (!($('#add_patron_to_group_position_id').find("option[value='" + patron.patron_id + "']").length)) {
                            // Create a DOM Option and de-select by default
                            var newOption = new Option(escape_str(patron.firstname) + ' ' + escape_str(patron.surname) + ' (' + escape_str(patron.address) + ')', patron.patron_id, false, false);
                            // Append it to the select
                            $('#add_patron_to_group_position_id').append(newOption);
                        }
                    }
                    // Redraw select with new options and enable
                    $('#add_patron_to_group_position_id').trigger('change');
                },
                function(jqXHR, textStatus, errorThrown) {
                    console.log("Fetch failed");
                }
            );
        });

        $("#addPatronToGroupForm").on('submit', function(e) {
            e.preventDefault();

            var group_id = $('#add_patron_to_group_group_id').val();
            var patron_id = $('#add_patron_to_group_patron_id').val();
            var after_id = $('#add_patron_to_group_position_id').val();

            var url = '/api/v1/contrib/logistics/groups/' + group_id + '/patrons';

            var posting = $.post(
                url,
                JSON.stringify({
                    "after_id": after_id != 0 ? after_id : null,
                    "patron_id": patron_id
                })
            );

            posting.done(function(data) {
                $('#addPatronToGroupModal').modal('hide');
            });

            posting.fail(function(data) {
                $('#add_patron_to_group_result').replaceWith('<div id="add_patron_to_group_result" class="alert alert-danger">Failure</div>');
            });
        });

        $('#addPatronToGroupModal').on('hidden.bs.modal', function (e) {
            $('#add_patron_to_group_result').replaceWith('<div id="add_patron_to_group_result"></div>');
            $('#add_patron_to_group_patron_id').val(null).trigger('change');
            $('#add_patron_to_group_position_id').val(null).trigger('change');
            $('#add_patron_to_group_position_id').find("option[value!='0']").remove().trigger('change');
        });
    });
</script>
