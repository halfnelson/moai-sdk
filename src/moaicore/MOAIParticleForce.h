// Copyright (c) 2010-2011 Zipline Games, Inc. All Rights Reserved.
// http://getmoai.com

#ifndef	MOAIPARTICLEFORCE_H
#define	MOAIPARTICLEFORCE_H

#include <moaicore/MOAITransform.h>

class MOAIParticle;
class MOAIParticleSystem;

//================================================================//
// MOAIParticleForce
//================================================================//
/**	@name	MOAIParticleForce
	@text	Particle force.
*/
class MOAIParticleForce :
	public MOAITransform {
private:

	u32			mShape;
	u32			mType;
	USVec2D		mVec;

	USVec2D		mWorldLoc;	
	USVec2D		mWorldVec;

	bool		mUseMass;

	// attractor coefficients
	float		mRadius;
	float		mPull;

	//----------------------------------------------------------------//
	static int		_initAttractor			( lua_State* L );
	static int		_initBasin				( lua_State* L );
	static int		_initLinear				( lua_State* L );
	static int		_initRadial				( lua_State* L );
	static int		_setType				( lua_State* L );
	
	//----------------------------------------------------------------//

public:
	
	enum {
		ATTRACTOR,
		BASIN,
		LINEAR,
		RADIAL,
	};
	
	enum {
		FORCE,
		GRAVITY,
		OFFSET,
	};
	
	DECL_LUA_FACTORY ( MOAIParticleForce )

	//----------------------------------------------------------------//
	void			Eval					( const MOAIParticle& particle, USVec2D& acceleration, USVec2D& offset );
					MOAIParticleForce		();
					~MOAIParticleForce		();
	void			OnDepNodeUpdate			();
	void			RegisterLuaClass		( USLuaState& state );
	void			RegisterLuaFuncs		( USLuaState& state );
	STLString		ToString				();
};

#endif
