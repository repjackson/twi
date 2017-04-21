@Modules = new Meteor.Collection 'modules'

Modules.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    doc.module_count = 0
    return


Modules.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()



if Meteor.isServer
    Modules.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    publishComposite 'module', (module_id)->
        {
            find: ->
                Modules.find module_id
            children: [
                { 
                    find: (module) ->
                        Sections.find
                            module_id: module_id
                    children: [
                        {
                            find: (section) ->
                                Questions.find
                                    section_id: section._id
                            children: [
                                {
                                    find: (question) ->
                                        Answers.find 
                                            question_id: question._id
                                    }
                                ]
                            }
                        
                        ]
                }
                {
                    find: (module) ->
                        Courses.find module.course_id
                }
            ]
        }