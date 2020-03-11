function tests = testOther
    addpath(genpath('PROSTATE'));
    addpath(genpath('minConf'));
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    unif = struct('name','PTV_68');
    unif.terms = {struct('type','unif','dose',80,'weight',1)};
    ldvc = struct('name','PTV_56');
    ldvc.terms = {struct('type','ldvc','dose',60,'percent',15,'weight',1)};
    udvc = struct('name','Rectum');
    udvc.terms = {struct('type','udvc','dose',30,'percent',15,'weight',1)};
    testCase.TestData.structs = {unif,ldvc,udvc};
    testCase.TestData.prob = FluenceMapOpt(testCase.TestData.structs);
end

function testGetPercentInit(testCase)
    prob = testCase.TestData.prob;
    p1 = prob.getPercent(2,1);
    p2 = prob.getPercent(3,1);
    assert(abs(p1 - 87.8227) <= 1e-4,'Wrong LDVC percent')
    assert(abs(p2 - 64.2727) <= 1e-4,'Wrong UDVC percent')
end

function testGetPercentZero(testCase)
    prob = testCase.TestData.prob;
    z = zeros(size(prob.x));
    p1 = prob.getPercent(2,1,z);
    p2 = prob.getPercent(3,1,z);
    assert(abs(p1 - 100) <= 1e-4,'Wrong LDVC percent')
    assert(abs(p2 - 0) <= 1e-4,'Wrong UDVC percent')
end

function testGetAreaInit(testCase)
    prob = testCase.TestData.prob;
    a1 = prob.getArea(2);
    a2 = prob.getArea(3);
    assert(abs(a1 - 1.8277e+03) <= 1e-1,'Wrong LDVC area')
    assert(abs(a2 - 4.2930e+03) <= 1e-1,'Wrong UDVC area')
end

function testGetAreaZero(testCase)
    prob = testCase.TestData.prob;
    z = zeros(size(prob.x));
    a1 = prob.getArea(2,z);
    a2 = prob.getArea(3,z);
    assert(abs(a1 - 0) <= 1e-1,'Wrong LDVC area')
    assert(abs(a2 - 0) <= 1e-1,'Wrong UDVC area')
end

function testGetPercentile(testCase)
    prob = testCase.TestData.prob;
    dose1 = prob.structs{1}.A*prob.x;
    dose2 = prob.structs{1}.A*zeros(size(prob.x));
    p1 = prob.getPercentile(dose1,0.95);
    p2 = prob.getPercentile(dose2,0.95);
    assert(abs(p1 - 78.6623) <= 1e-4,'Wrong x0 percentile')
    assert(abs(p2 - 0) <= 1e-4,'Wrong 0 percentile')
end

% test getVoxelDose?
% test printStats?
