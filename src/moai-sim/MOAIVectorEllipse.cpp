// Copyright (c) 2010-2011 Zipline Games, Inc. All Rights Reserved.
// http://getmoai.com

#include "pch.h"
#include <moai-sim/MOAIVectorDrawing.h>
#include <moai-sim/MOAIVectorEllipse.h>
#include <tesselator.h>

//================================================================//
// MOAIVectorEllipse
//================================================================//

//----------------------------------------------------------------//
void MOAIVectorEllipse::AddFillContours ( MOAIVectorDrawing& drawing, TESStesselator* tess ) {

	u32 steps = drawing.GetStyle ().GetCircleResolution ();

	ZLVec2D* verts = ( ZLVec2D* )alloca ( sizeof ( ZLVec2D ) * steps );

	float step = ( float )TWOPI / ( float )steps;
	float angle = ( float )PI;
	
	for ( u32 i = 0; i < steps; ++i, angle += step ) {
		verts [ i ].mX = this->mLoc.mX + ( Cos ( angle ) * this->mXRad );
		verts [ i ].mY = this->mLoc.mY + ( Sin ( angle ) * this->mYRad );
	}
	tessAddContour ( tess, 2, verts, sizeof ( ZLVec2D ), steps );
}

//----------------------------------------------------------------//
void MOAIVectorEllipse::AddStrokeContours ( MOAIVectorDrawing& drawing, TESStesselator* tess ) {

	MOAIVectorShape::AddStrokeContours ( drawing, tess );
}

//----------------------------------------------------------------//
void MOAIVectorEllipse::Init ( float x, float y, float xRad, float yRad ) {

	this->mLoc.Init ( x, y );
	this->mXRad = xRad;
	this->mYRad = yRad;
	this->SetOpen ( false );
}

//----------------------------------------------------------------//
MOAIVectorEllipse::MOAIVectorEllipse () {
}

//----------------------------------------------------------------//
MOAIVectorEllipse::~MOAIVectorEllipse () {
}