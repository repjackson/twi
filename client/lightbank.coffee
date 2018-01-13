FlowRouter.route '/lightbank', action: ->
    BlazeLayout.render 'layout', 
        main: 'lightbank'

Template.lightbank.onCreated ->
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type = 'lightbank'
            author_id = null
            parent_id = null
            tag_limit = 20
            doc_limit = 5
            view_published = 
                if Session.equals('admin_mode', true) then true else Session.get('view_published')
            view_read = null
            view_bookmarked = null
            view_resonates = null
            view_complete = null
            view_images = null
            view_lightbank_type = null

            )

Template.lightbank_card.onCreated ->
    @autorun -> Meteor.subscribe 'usernames'

Template.lightbank.onCreated ->
    @autorun -> Meteor.subscribe 'usernames'


Template.lightbank.helpers
    items: -> Docs.find {type: 'lightbank'}

Template.lightbank_card.helpers
    theme_tag_class: -> if @valueOf() in selected_theme_tags.array() then 'blue' else 'basic'
    location_tag_class: -> if @valueOf() in selected_location_tags.array() then 'blue' else 'basic'

Template.lightbank_card.events
    'click .theme_tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())
    'click .location_tag': -> if @valueOf() in selected_location_tags.array() then selected_location_tags.remove(@valueOf()) else selected_location_tags.push(@valueOf())


            
Template.lightbank.events
    'click #add_item': ->
        id = Docs.insert
            type: 'lightbank'
        FlowRouter.go "/lightbank/#{id}/edit"
        
        
FlowRouter.route '/lightbank/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_lightbank_item'

FlowRouter.route '/lightbank/:doc_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_lightbank_item'

Template.view_lightbank_item.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.view_lightbank_item.helpers
    lightbank_item: -> Docs.findOne FlowRouter.getParam('doc_id')
    
Template.edit_lightbank_item.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.edit_lightbank_item.helpers
    lightbank_item: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.edit_lightbank_item.events
    'click #delete_item': ->
        swal {
            title: 'Delete Lightbank Entry?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            lightbank = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.remove lightbank._id, ->
                FlowRouter.go "/lightbank"        