function update_psystems()
	local timenow = time()
	for ps in all(particle_systems) do
		update_ps(ps, timenow)
	end
end

function update_ps(ps, timenow)
	for et in all(ps.emittimers) do
		local keep = et.timerfunc(ps, et.params)
		if (keep==false) then
			del(ps.emittimers, et)
		end
	end

	for p in all(ps.particles) do
		p.phase = (timenow-p.starttime)/(p.deathtime-p.starttime)

		for a in all(ps.affectors) do
			a.affectfunc(p, a.params)
		end

		p.x += p.vx
		p.y += p.vy
		
		local dead = false
		if (p.x<0 or p.x>127 or p.y<0 or p.y>127) then
			dead = true
		end

		if (timenow>=p.deathtime) then
			dead = true
		end

		if (dead==true) then
			del(ps.particles, p)
		end
	end
	
	if (ps.autoremove==true and count(ps.particles)<=0) then
		del(particle_systems, ps)
	end
end

function make_starfield_ps()
	local ps = make_psystem(4,6, 1,2,0.5,0.5)
	ps.autoremove = false
	add(ps.emittimers,
		{
			timerfunc = emittimer_constant,
			params = {nextemittime = time(), speed = 0.01}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_box,
			params = { minx = 125, maxx = 127, miny = 0, maxy= 127, minstartvx = -2.0, maxstartvx = -0.5, minstartvy = 0, maxstartvy=0 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_pixel,
			params = { colors = {7,6,7,6,7,6,6,7,6,7,7,6,6,7} }
		}
	)
end

function make_blood_ps(ex,ey,flipx)
	local ps = make_psystem(2,3, 1,2,0.5,0.5)
	
	add(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 30}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_point,
			params = { x = ex, y = ey, minstartvx = 1, maxstartvx = 3, minstartvy = -3, maxstartvy=-2 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_pixel,
			params = { colors = {8} }
		}
	)

    sg=1
    if flipx then
        sg=-1
    end

	add(ps.affectors,
		{ 
			affectfunc = affect_force,
			params = { fx = 0.4*sg, fy = 0.4 }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_stopzone,
			params = { zoneminx = 0, zonemaxx = 127, zoneminy = 120, zonemaxy = 127 }
		}
	)
end


particle_systems = {}
function make_psystem(minlife, maxlife, minstartsize, maxstartsize, minendsize, maxendsize)
	local ps = {}
	-- global particle system params
	ps.autoremove = true

	ps.minlife = minlife
	ps.maxlife = maxlife
	
	ps.minstartsize = minstartsize
	ps.maxstartsize = maxstartsize
	ps.minendsize = minendsize
	ps.maxendsize = maxendsize
	
	-- container for the particles
	ps.particles = {}

	-- emittimers dictate when a particle should start
	-- they called every frame, and call emit_particle when they see fit
	-- they should return false if no longer need to be updated
	ps.emittimers = {}

	-- emitters must initialize p.x, p.y, p.vx, p.vy
	ps.emitters = {}

	-- every ps needs a drawfunc
	ps.drawfuncs = {}

	-- affectors affect the movement of the particles
	ps.affectors = {}

	add(particle_systems, ps)

	return ps
end

function emit_particle(psystem)
	local p = {}

	local e = psystem.emitters[flr(rnd(count(psystem.emiters)))+1]
	e.emitfunc(p, e.params)	

	p.phase = 0
	p.starttime = time()
	p.deathtime = time()+rnd(psystem.maxlife-psystem.minlife)+psystem.minlife

	p.startsize = rnd(psystem.maxstartsize-psystem.minstartsize)+psystem.minstartsize
	p.endsize = rnd(psystem.maxendsize-psystem.minendsize)+psystem.minendsize

	add(psystem.particles, p)
end

function emittimer_constant(ps, params)
	if (params.nextemittime<=time()) then
		emit_particle(ps)
		params.nextemittime += params.speed
	end
	return true
end

function emitter_box(p, params)
	p.x = rnd(params.maxx-params.minx)+params.minx
	p.y = rnd(params.maxy-params.miny)+params.miny

	p.vx = rnd(params.maxstartvx-params.minstartvx)+params.minstartvx
	p.vy = rnd(params.maxstartvy-params.minstartvy)+params.minstartvy
end

function emittimer_burst(ps, params)
	for i=1,params.num do
		emit_particle(ps)
	end
	return false
end

function emitter_point(p, params)
	p.x = params.x
	p.y = params.y

	p.vx = rnd(params.maxstartvx-params.minstartvx)+params.minstartvx
	p.vy = rnd(params.maxstartvy-params.minstartvy)+params.minstartvy
end

function affect_force(p, params)
	p.vx += params.fx
	p.vy += params.fy
end

function affect_forcezone(p, params)
	if (p.x>=params.zoneminx and p.x<=params.zonemaxx and p.y>=params.zoneminy and p.y<=params.zonemaxy) then
		p.vx += params.fx
		p.vy += params.fy
	end
end

function affect_stopzone(p, params)
	if (p.x>=params.zoneminx and p.x<=params.zonemaxx and p.y>=params.zoneminy and p.y<=params.zonemaxy) then
		p.vx = 0
		p.vy = 0
	end
end

function draw_ps_pixel(ps, params)
	for p in all(ps.particles) do
		c = flr(p.phase*count(params.colors))+1
		pset(p.x,p.y,params.colors[c])
	end	
end

function draw_ps(ps, params)
	for df in all(ps.drawfuncs) do
		df.drawfunc(ps, df.params)
	end
end