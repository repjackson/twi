# import fullcalendar from 'fullcalendar'


FlowRouter.route '/checkin', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'checkin'

# FlowRouter.route '/checkin/calendar', action: (params) ->
#     BlazeLayout.render 'layout',
#         # cloud: 'cloud'
#         main: 'checkin_calendar_view'





# Template.checkin_calendar_view.onRendered ->
#     $( '#checkin-calendar' ).fullcalendar();
#     console.log fullcalendar

# Template.checkin_calendar_view.helpers
#     checkin_calendar_options: ->
#         {
#             defaultView: 'basicWeek'

#         }



Template.checkin.helpers
    # docs: -> 
    #     Docs.find {type:'checkin' }, 
    #         sort:
    #             timestamp: -1
    #         limit: 10

    # tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'



Template.checkin.events
    'click #create_checkin': ->
        new_checkin_doc_id = Docs.insert 
            tags: []
            type: 'checkin'
        FlowRouter.go("/edit/#{new_checkin_doc_id}")

    'keyup #quick_add': (e,t)->
        e.preventDefault
        tag = $('#quick_add').val().toLowerCase()
        if e.which is 13
            if tag.length > 0
                split_tags = tag.match(/\S+/g)
                $('#quick_add').val('')
                Meteor.call 'add_checkin', split_tags, (err,res)->
                    FlowRouter.go "/view/#{res}"
                # selected_theme_tags.clear()
                # for tag in split_tags
                #     selected_theme_tags.push tag

# Template.checkin_doc_view.helpers
#     tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

#     # checkin_tags: -> _.difference(@tags, 'checkin')
    
#     checkin_card_class: -> if @published then 'blue' else ''


# Template.checkin_doc_view.events
#     'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())