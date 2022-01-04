<!-- Add patron to group modal -->
<div class="modal" id="addPatronToGroupModal" tabindex="-1" role="dialog" aria-labelledby="addPatronToGroupLabel">
    <form id="addPatronToGroupForm" class="validated">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="closebtn" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="addPatronToGroupLabel">Add to group</h4>
                </div>
                <div class="modal-body">
                    <div id="add_patron_to_group_result"></div>
                    <input type="hidden" name="add_patron_to_group_group_id" id="add_patron_to_group_group_id">
                    <fieldset class="rows">
                        <ol>
                            <li>
                                <div class="hint">Enter patron card number or partial name:</div>
                                <label class="required" for="add_patron_to_group_patron_id">Patron: </label>
                                <select name="add_patron_to_group_patron_id" id="add_patron_to_group_patron_id" required="required">
                                    <option></option>
                                </select>
                            </li>
                            <li>
                                <div class="hint">Select which patron to place this new patron after:</div>
                                <label for="add_patron_to_group_position_id">After: </label>
                                <select name="add_patron_to_group_position_id" id="add_patron_to_group_position_id">
                                    <option value="0">At end</option>
                                </select>
                            </li>
                        </ol>
                    </fieldset> <!-- /.rows -->
                </div> <!-- /.modal-body -->
                <div class="modal-footer">
                    <button type="submit" class="btn btn-default" id="add_patron_to_group_confirm">Confirm</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div> <!-- /.modal-footer -->
            </div> <!-- /.modal-content -->
        </div> <!-- /.modal-dialog -->
    </form> <!-- /#add_patron_to_group_form -->
</div> <!-- /#addPatronToGroupModal -->
