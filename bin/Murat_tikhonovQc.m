function [mtik0C,residualQc_k,LcQc,tik0_regC]...
                                =...
    Murat_tikhonovQc(outputLCurve,Qm_k,Wc,Gc,lCurveQc)

%Weighted tikhonov inversion with SVD for Qc. Also creates L-curve.
dck                             =   Wc*Qm_k;
[Uc,Sc,Vc]                      =   svd(Gc);

LcQc                            =...
    figure('Name','L-curve Qc','NumberTitle','off');
[rho,eta,reg_param]             =...
    l_curve_tikh_svd(Uc,diag(Sc),dck,100);
plot_lc(rho,eta,'-',1,reg_param)

if outputLCurve == 1
    tik0_regC                   =...
        input('Your damping parameter for coda: ');
else
    tik0_regC                   =   lCurveQc;
end

mtik0C                          =...
    tikhonov(Uc,diag(Sc),Vc,dck,tik0_regC);
residualQc_k                    =   sum(abs(dck-Gc*mtik0C).^2);
end