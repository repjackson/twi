publishComposite 'debrief_questions', (module_number)->
    {
        find: ->
            Docs.find 
                type: 'question'
                debrief: true
                module_number: module_number
        children: [
            { find: (question) ->
                Docs.find
                    type: 'answer'
                    question_id: question._id
            }
        ]
    }    
    
    
Meteor.publish 'module_lightwork', (module_number) ->
    Docs.find
        type: 'section'
        lightwork: true
        module_number: module_id
            
            
publishComposite 'section', (course, module_number, section_number)->
        {
            find: ->
                Docs.find 
                    type: 'section'
                    course: course
                    module_number: module_number
                    section_number
            children: [
                {
                    find: (section) ->
                        Docs.find
                            section_id: section._id
                            type: 'question'
                    children: [
                        {
                            find: (question) ->
                                Docs.find 
                                    question_id: question._id
                                    type: 'answer'
                            }
                        ]
                    }
                
                ]
        }
        


publishComposite 'module_files', (module_id)->
    {
        find: ->
            Docs.find 
                type: 'file'
                module_id: module_id
        # children: [
        #     { find: (question) ->
        #         Answers.find
        #             question_id: question._id
        #     }
        # ]
    }    



publishComposite 'module', (course, module_number)->
    {
        find: ->
            Docs.find 
                type: 'module'
                course: course
                number: module_number
        children: [
            { 
                find: (module) ->
                    Docs.find
                        type: 'section'
                        course: course
                        module_number: module_number
                # children: [
                #     {
                #         find: (section) ->
                #             Docs.find
                #                 section_id: section._id
                #                 type: 'question'
                #         children: [
                #             {
                #                 find: (question) ->
                #                     Docs.find 
                #                         question_id: question._id
                #                         type: 'answer'
                #                 }
                #             ]
                #         }
                    
                #     ]
            }
            {
                find: (module) ->
                    Docs.find
                        type: 'course'
                        slug: module.course
            }
        ]
    }
    
    
    
publishComposite 'course_by_id', (course_id)->
    {
        find: ->
            Courses.find course_id
        # children: [
        #     { find: (course) ->
        #         Docs.find
        #             course: course.slug
        #             type: 'module'
        #     # children: [
        #     #     {
        #     #         find: (module) ->
        #     #             Docs.find 
        #     #                 _id: module.section_id
        #     #                 type: 'section'
        #     #     }
        #     # ]    
        #     }
        #     {
        #         find: (course) ->
        #             Meteor.users.find course.author_id
        #     }
        # ]
    }          
    
publishComposite 'course_by_slug', (course_slug)->
    {
        find: ->
            Courses.find 
                slug: course_slug
        # children: [
        #     { find: (course) ->
        #         Modules.find
        #             course: course.slug
        #             type: 'module'
        #     # children: [
        #     #     {
        #     #         find: (module) ->
        #     #             Docs.find 
        #     #                 _id: module.section_id
        #     #                 type: 'section'
        #     #     }
        #     # ]    
        #     }
        #     {
        #         find: (course) ->
        #             Meteor.users.find course.author_id
        #     }
        # ]
    }            
    
    
    
Meteor.publish 'courses', (view_mode)->
    
    me = Meteor.users.findOne @userId
    self = @
    match = {}
    if view_mode is 'mine'
        match.slug = $in: me.courses
    if not @userId or not Roles.userIsInRole(@userId, ['admin'])
        match.published = true
            
    Courses.find match
    
    
    
Meteor.publish 'sol_members', (slug, selected_course_member_tags) ->
    match = {}
    if selected_course_member_tags.length > 0 then match.tags = $all: selected_course_member_tags
    match._id = $ne: @userId
    match["profile.published"] = true
    match.courses = $in: [slug]
    
    Meteor.users.find match

    
    
    # Meteor.users.find
    #     # roles: $in: ['sol_member', 'sol_demo_member']
        
        
Meteor.publish 'course_member_tags', (slug, selected_course_member_tags)->
    self = @
    match = {}
    if selected_course_member_tags.length > 0 then match.tags = $all: selected_course_member_tags
    match._id = $ne: @userId
    # match["profile.published"] = true
    match.courses = $in: [slug]

    # console.log match

    people_cloud = Meteor.users.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_course_member_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 20 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    # console.log 'cloud, ', people_cloud
    people_cloud.forEach (tag, i) ->
        self.added 'course_member_tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    self.ready()




Courses.allow
    insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or userId
    update: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or userId
    remove: (userId, doc) -> 
        Roles.userIsInRole(userId, 'admin')
        # need prevention of deletion if remaing moduels language