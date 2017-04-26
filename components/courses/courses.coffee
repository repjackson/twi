FlowRouter.route '/courses', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'courses'


Meteor.users.helpers
    course_ob: -> 
        Docs.find
            type: 'course'
            _id: $in: @courses




if Meteor.isClient
    Template.courses.onCreated -> 
        Meteor.subscribe('courses')

    Template.courses.helpers
        courses: -> 
            Docs.find
                type: 'course'
                published: true
    
        # unpublished_courses: -> 
        #     Docs.find
        #         type: 'course'
        #         published: false
    

    Template.courses.events
        'click #add_course': ->
            id = Docs.insert
                type: 'course'
                published: false
            FlowRouter.go "/edit/#{id}"
            
            

if Meteor.isServer
    publishComposite 'course', (course_id)->
        {
            find: ->
                Docs.find course_id
            children: [
                { find: (course) ->
                    Docs.find
                        course_id: course._id
                        type: 'module'
                children: [
                    {
                        find: (module) ->
                            Docs.find 
                                _id: module.section_id
                                type: 'section'
                    }
                ]    
                }
                {
                    find: (course) ->
                        Meteor.users.find course.author_id
                }
            ]
        }            
        
    Meteor.publish 'courses', ->
        self = @
        match = {}
        if not @userId or not Roles.userIsInRole(@userId, ['admin'])
            match.published = true
                
        match.type = 'course'        
                
        Docs.find match