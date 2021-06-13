require 'pry'
require 'json'

class Application

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)
    if req.get? # handles get requests
      if req.path.match(/test/) 
        return [200, { 'Content-Type' => 'application/json' }, [ {:message => "response success"}.to_json ]]
      elsif req.path.match(/tasks/)
        array = handle_cat_reqq
        resp.write array.to_json
        resp.status = 200
      else
        resp.write "Path Not Found"
        resp.status = 404
      end
    elsif req.post? # handles Post Requests
      if req.path.match(/tasks/)
        puts "before hnd pst"
        handle_post(req)
        puts "after hnd pst"
        # binding.pry
        an_obj = {id: Task.last.id, category: Task.last.category.name, text: Task.last.text}
        puts "after hnd cat" 
        resp.write an_obj.to_json
      else
        resp.write "Path Not Found"
        resp.status = 404
      end
    elsif req.delete? # handles Delete requests
      if req.path.match(/tasks/)
        # binding.pry
        puts "inside del"
        unwanted_id = req.path.split('/').last
        handle_del(unwanted_id)
        # res.write "Task Delete"
        # res.status = 200
      else
        resp.write "Path Not Found"
        resp.status = 404
      end
    else 
      resp.write "Path Not Found"
      resp.status = 404
    end

    resp.finish
  end

  def handle_post(req)
    puts "in hnd post start"
    input = JSON.parse(req.body.read)    
    new_task = Task.create(text: input["text"])
    new_cat = Category.find_or_create_by(name: input["category"])
    new_cat.tasks << new_task
    puts "in hnd post end"
  end

  def handle_cat_reqq
    puts "in hnd cat"
    Category.joins(:tasks).select('categories.name AS category, tasks.text, tasks.id')
  end

  def handle_del(unwanted_id)
    unwanted = Task.find(unwanted_id)
    unwanted.destroy
  end

end
