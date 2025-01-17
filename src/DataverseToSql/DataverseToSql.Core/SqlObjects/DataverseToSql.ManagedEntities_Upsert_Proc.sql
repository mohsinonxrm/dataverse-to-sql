﻿-- Copyright (c) Microsoft Corporation.
-- Licensed under the MIT License.

CREATE PROCEDURE [DataverseToSql].[ManagedEntities_Upsert]
	@EntityName [DataverseToSql].[EntityType],
	@TargetSchema SYSNAME,
	@TargetTable SYSNAME,
	@State INT = NULL,
	@SchemaHash NVARCHAR(128) = NULL,
	@FullLoadInnerQuery NVARCHAR(MAX) = NULL,
	@IncrementalInnerQuery NVARCHAR(MAX) = NULL,
	@OpenrowsetQuery NVARCHAR(MAX) = NULL
AS
IF NOT EXISTS (
	SELECT * FROM [DataverseToSql].[ManagedEntities]
	WHERE [EntityName] = @EntityName
)
BEGIN
	INSERT INTO [DataverseToSql].[ManagedEntities](
		[EntityName],
		[State],
		[SchemaHash],
		[TargetSchema],
		[TargetTable],
		[FullLoadInnerQuery],
		[IncrementalInnerQuery],
		[OpenrowsetQuery]
	)
	VALUES (
		@EntityName,
		@State,
		@SchemaHash,
		@TargetSchema,
		@TargetTable,
		@FullLoadInnerQuery,
		@IncrementalInnerQuery,
		@OpenrowsetQuery
	)
END
ELSE
BEGIN
	UPDATE [DataverseToSql].[ManagedEntities]
	SET
		[State] = ISNULL(@State, [State]),
		[SchemaHash] = ISNULL(@SchemaHash, [SchemaHash]),
		[FullLoadInnerQuery] = ISNULL(@FullLoadInnerQuery, [FullLoadInnerQuery]),
		[IncrementalInnerQuery] = ISNULL(@IncrementalInnerQuery, [IncrementalInnerQuery]),
		[OpenrowsetQuery] = ISNULL(@OpenrowsetQuery, [OpenrowsetQuery])
	WHERE
		[EntityName] = @EntityName
END