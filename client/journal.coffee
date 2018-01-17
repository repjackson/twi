FlowRouter.route '/journal', action: ->
    BlazeLayout.render 'layout', 
        main: 'view_journal_section'

Template.view_journal_section.onCreated ->
    @autorun => 
        Meteor.subscribe('new_facet', 
            selected_theme_tags.array()
            type = 'journal'
            parent_id = null
            tag_limit = 20
            doc_limit = 5

            )

Template.journal_card.onCreated ->
    # @autorun -> Meteor.subscribe 'usernames'

Template.view_journal_section.onCreated ->
    # @autorun -> Meteor.subscribe 'usernames'


Template.view_journal_section.helpers
    entries: -> 
        Docs.find {
            type: 'journal', 
            published: $in: [1,0]
            }

Template.journal_card.helpers
    theme_tag_class: -> if @valueOf() in selected_theme_tags.array() then 'blue' else 'basic'
    location_tag_class: -> if @valueOf() in selected_location_tags.array() then 'blue' else 'basic'

Template.journal_card.events
    'click .theme_tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())
    'click .location_tag': -> if @valueOf() in selected_location_tags.array() then selected_location_tags.remove(@valueOf()) else selected_location_tags.push(@valueOf())


            
Template.view_journal_section.events
    'click #add_entry': ->
        id = Docs.insert
            type: 'journal'
        FlowRouter.go "/journal/#{id}/edit"
        
    
    
        
FlowRouter.route '/journal/:doc_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_journal_entry'
        
        
FlowRouter.route '/journal/:doc_id/view', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_journal_entry'

Template.edit_journal_entry.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.edit_journal_entry.helpers
    journal_entry: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.view_journal_entry.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.view_journal_entry.helpers
    journal_entry: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.edit_journal_entry.events
    'click #delete_entry': ->
        swal {
            title: 'Delete journal entry?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            journal = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.remove journal._id, ->
                FlowRouter.go "/journal"        